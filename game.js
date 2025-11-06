const canvas = document.getElementById("game-canvas");
const ctx = canvas.getContext("2d");

const hudLevel = document.getElementById("hud-level");
const hudScore = document.getElementById("hud-score");
const hudTime = document.getElementById("hud-time");

const LEVELS = [
  {
    name: "Isla de los Cantos",
    orbCount: 5,
    hazardCount: 3,
    beaconPos: { x: canvas.width - 90, y: canvas.height / 2 },
    palette: {
      background: ["#041029", "#0b3d91"],
      orb: "#00ffc6",
      hazard: "#c770ff",
      beacon: "#6dff77",
      aura: "rgba(0, 255, 198, 0.35)",
    },
    playerSpeed: 2.6,
    fogSpeed: 1.2,
  },
  {
    name: "Bahía de Cristal",
    orbCount: 7,
    hazardCount: 4,
    beaconPos: { x: canvas.width / 2, y: 80 },
    palette: {
      background: ["#020923", "#0066b2"],
      orb: "#48f9ff",
      hazard: "#ff77aa",
      beacon: "#93ff6d",
      aura: "rgba(72, 249, 255, 0.35)",
    },
    playerSpeed: 2.9,
    fogSpeed: 1.5,
  },
  {
    name: "Fjord de Lumen",
    orbCount: 8,
    hazardCount: 5,
    beaconPos: { x: 120, y: canvas.height - 80 },
    palette: {
      background: ["#01050f", "#00363d"],
      orb: "#9dffef",
      hazard: "#d398ff",
      beacon: "#c5ff6d",
      aura: "rgba(157, 255, 239, 0.4)",
    },
    playerSpeed: 3.2,
    fogSpeed: 1.8,
  },
];

const INPUT = {
  up: false,
  down: false,
  left: false,
  right: false,
};

const clamp = (value, min, max) => Math.min(Math.max(value, min), max);

class Entity {
  constructor(x, y, radius, color) {
    this.x = x;
    this.y = y;
    this.radius = radius;
    this.baseRadius = radius;
    this.color = color;
    this.pulse = Math.random() * Math.PI * 2;
  }

  drawGlow(glowColor) {
    const gradient = ctx.createRadialGradient(
      this.x,
      this.y,
      0,
      this.x,
      this.y,
      this.radius * 2.5
    );
    gradient.addColorStop(0, glowColor);
    gradient.addColorStop(1, "rgba(0,0,0,0)");
    ctx.fillStyle = gradient;
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.radius * 2.5, 0, Math.PI * 2);
    ctx.fill();
  }
}

class Player extends Entity {
  constructor() {
    super(canvas.width / 2, canvas.height / 2, 16, "#ffffff");
    this.speed = LEVELS[0].playerSpeed;
    this.energy = 3;
  }

  reset(level) {
    this.x = canvas.width / 2;
    this.y = canvas.height - 80;
    this.speed = level.playerSpeed;
    this.radius = this.baseRadius;
  }

  update(delta) {
    let dx = 0;
    let dy = 0;
    if (INPUT.up) dy -= 1;
    if (INPUT.down) dy += 1;
    if (INPUT.left) dx -= 1;
    if (INPUT.right) dx += 1;

    if (dx !== 0 || dy !== 0) {
      const length = Math.hypot(dx, dy) || 1;
      dx /= length;
      dy /= length;
    }

    this.x += dx * this.speed * delta;
    this.y += dy * this.speed * delta;
    this.x = clamp(this.x, this.radius, canvas.width - this.radius);
    this.y = clamp(this.y, this.radius, canvas.height - this.radius);
  }

  draw(level) {
    const gradient = ctx.createRadialGradient(
      this.x,
      this.y,
      0,
      this.x,
      this.y,
      this.radius * 2
    );
    gradient.addColorStop(0, "rgba(255,255,255,0.95)");
    gradient.addColorStop(1, level.palette.aura);
    ctx.fillStyle = gradient;
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = "rgba(255,255,255,0.4)";
    ctx.lineWidth = 2;
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.radius + 8, 0, Math.PI * 2);
    ctx.stroke();
  }
}

class Hazard extends Entity {
  constructor(x, y, radius, color, speed) {
    super(x, y, radius, color);
    this.speed = speed;
    this.direction = Math.random() * Math.PI * 2;
  }

  update(delta) {
    this.pulse += delta * 0.005;
    this.radius = this.baseRadius + Math.sin(this.pulse) * 2;
    this.x += Math.cos(this.direction) * this.speed * delta;
    this.y += Math.sin(this.direction) * this.speed * delta;

    if (this.x < this.radius || this.x > canvas.width - this.radius) {
      this.direction = Math.PI - this.direction;
    }
    if (this.y < this.radius || this.y > canvas.height - this.radius) {
      this.direction = -this.direction;
    }

    this.x = clamp(this.x, this.radius, canvas.width - this.radius);
    this.y = clamp(this.y, this.radius, canvas.height - this.radius);
  }

  draw() {
    this.drawGlow("rgba(199, 112, 255, 0.25)");
    ctx.fillStyle = this.color;
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
    ctx.fill();
  }
}

class Orb extends Entity {
  update(delta) {
    this.pulse += delta * 0.005;
    this.radius = this.baseRadius + Math.sin(this.pulse) * 3;
  }

  draw() {
    this.drawGlow("rgba(0,255,198,0.35)");
    ctx.fillStyle = this.color;
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
    ctx.fill();
  }
}

class Beacon extends Entity {
  constructor(x, y, color) {
    super(x, y, 20, color);
  }

  draw(level, energized) {
    const glow = ctx.createRadialGradient(
      this.x,
      this.y,
      0,
      this.x,
      this.y,
      120
    );
    glow.addColorStop(0, energized ? level.palette.beacon : "rgba(109,255,119,0.2)");
    glow.addColorStop(1, "rgba(0,0,0,0)");
    ctx.fillStyle = glow;
    ctx.beginPath();
    ctx.arc(this.x, this.y, 120, 0, Math.PI * 2);
    ctx.fill();

    ctx.strokeStyle = energized ? level.palette.beacon : "rgba(255,255,255,0.25)";
    ctx.lineWidth = energized ? 6 : 3;
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.radius * 2, 0, Math.PI * 2);
    ctx.stroke();

    ctx.fillStyle = energized ? level.palette.beacon : "rgba(255,255,255,0.4)";
    ctx.beginPath();
    ctx.arc(this.x, this.y, this.radius, 0, Math.PI * 2);
    ctx.fill();
  }
}

const player = new Player();

const gameState = {
  levelIndex: 0,
  score: 0,
  collected: 0,
  energy: 3,
  hazards: [],
  orbs: [],
  beacon: null,
  elapsed: 0,
  lastTime: 0,
  status: "playing",
};

function randomPosition(radius) {
  const padding = 40;
  return {
    x: Math.random() * (canvas.width - radius * 2 - padding) + radius + padding / 2,
    y: Math.random() * (canvas.height - radius * 2 - padding) + radius + padding / 2,
  };
}

function spawnLevel(level) {
  gameState.orbs = [];
  gameState.hazards = [];
  gameState.collected = 0;
  player.reset(level);
  const usedPositions = [];

  for (let i = 0; i < level.orbCount; i++) {
    const pos = findFreePosition(usedPositions, 18);
    usedPositions.push(pos);
    gameState.orbs.push(new Orb(pos.x, pos.y, 12, level.palette.orb));
  }

  for (let i = 0; i < level.hazardCount; i++) {
    const pos = findFreePosition(usedPositions, 20);
    usedPositions.push(pos);
    gameState.hazards.push(
      new Hazard(pos.x, pos.y, 14, level.palette.hazard, level.fogSpeed)
    );
  }

  const beaconPos = level.beaconPos;
  gameState.beacon = new Beacon(beaconPos.x, beaconPos.y, level.palette.beacon);
}

function findFreePosition(existing, radius) {
  let attempt = 0;
  while (attempt < 1000) {
    const pos = randomPosition(radius);
    const collision = existing.some((item) => Math.hypot(item.x - pos.x, item.y - pos.y) < radius * 4);
    if (!collision) return pos;
    attempt++;
  }
  return { x: radius * 2, y: radius * 2 };
}

function nextLevel() {
  if (gameState.levelIndex < LEVELS.length - 1) {
    gameState.levelIndex += 1;
    gameState.score += 500;
    gameState.energy = clamp(gameState.energy + 1, 0, 3);
    spawnLevel(getCurrentLevel());
  } else {
    gameState.score += 1000;
    gameState.status = "completed";
  }
}

function resetGame() {
  gameState.levelIndex = 0;
  gameState.score = 0;
  gameState.energy = 3;
  gameState.elapsed = 0;
  gameState.status = "playing";
  spawnLevel(getCurrentLevel());
}

function getCurrentLevel() {
  return LEVELS[gameState.levelIndex];
}

function updateHUD() {
  const level = getCurrentLevel();
  hudLevel.textContent = `${level.name} (Nivel ${gameState.levelIndex + 1})`;
  hudScore.textContent = `Puntos: ${gameState.score}`;
  const seconds = Math.floor(gameState.elapsed / 1000);
  const mm = String(Math.floor(seconds / 60)).padStart(2, "0");
  const ss = String(seconds % 60).padStart(2, "0");
  hudTime.textContent = `Tiempo: ${mm}:${ss}`;
}

function drawBackground(level) {
  const gradient = ctx.createLinearGradient(0, 0, 0, canvas.height);
  gradient.addColorStop(0, level.palette.background[0]);
  gradient.addColorStop(1, level.palette.background[1]);
  ctx.fillStyle = gradient;
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  ctx.strokeStyle = "rgba(255,255,255,0.08)";
  ctx.lineWidth = 1;
  for (let i = 0; i < 8; i++) {
    ctx.beginPath();
    ctx.ellipse(
      canvas.width / 2,
      canvas.height / 2,
      120 + i * 60,
      40 + i * 20,
      (Math.PI / 4) * (i % 2 === 0 ? 1 : -1),
      0,
      Math.PI * 2
    );
    ctx.stroke();
  }
}

function checkCollisions(delta) {
  const level = getCurrentLevel();
  for (let i = gameState.orbs.length - 1; i >= 0; i--) {
    const orb = gameState.orbs[i];
    if (Math.hypot(player.x - orb.x, player.y - orb.y) < player.radius + orb.radius) {
      gameState.orbs.splice(i, 1);
      gameState.collected += 1;
      gameState.score += 150;
    }
  }

  let hitHazard = false;
  for (const hazard of gameState.hazards) {
    if (Math.hypot(player.x - hazard.x, player.y - hazard.y) < player.radius + hazard.radius) {
      hitHazard = true;
      break;
    }
  }

  if (hitHazard) {
    gameState.energy -= 1;
    player.radius = Math.max(8, player.radius - 2);
    if (gameState.energy <= 0) {
      gameState.status = "defeat";
    } else {
      spawnLevel(level);
    }
  }
}

function drawEnergy() {
  const barWidth = 160;
  const barHeight = 12;
  const padding = 24;
  const x = padding;
  const y = padding + 40;
  ctx.fillStyle = "rgba(255,255,255,0.1)";
  ctx.fillRect(x, y, barWidth, barHeight);
  const fillWidth = (barWidth * gameState.energy) / 3;
  const gradient = ctx.createLinearGradient(x, y, x + barWidth, y);
  gradient.addColorStop(0, "#00ffc6");
  gradient.addColorStop(1, "#6dff77");
  ctx.fillStyle = gradient;
  ctx.fillRect(x, y, fillWidth, barHeight);
  ctx.strokeStyle = "rgba(255,255,255,0.25)";
  ctx.strokeRect(x, y, barWidth, barHeight);
  ctx.fillStyle = "rgba(255,255,255,0.8)";
  ctx.font = "12px Montserrat, sans-serif";
  ctx.fillText("Energía", x, y - 4);
}

function drawStatusOverlay() {
  if (gameState.status === "playing") return;

  ctx.fillStyle = "rgba(3, 5, 15, 0.75)";
  ctx.fillRect(0, 0, canvas.width, canvas.height);

  ctx.fillStyle = "#ffffff";
  ctx.font = "36px Montserrat, sans-serif";
  ctx.textAlign = "center";
  ctx.fillText(
    gameState.status === "completed" ? "¡EcoRutas Restauradas!" : "Aurora necesita más energía",
    canvas.width / 2,
    canvas.height / 2 - 20
  );

  ctx.font = "18px Montserrat, sans-serif";
  ctx.fillText("Pulsa R para reiniciar", canvas.width / 2, canvas.height / 2 + 20);
}

function update(delta) {
  if (gameState.status !== "playing") return;
  const level = getCurrentLevel();
  player.update(delta);

  for (const hazard of gameState.hazards) {
    hazard.update(delta);
  }

  for (const orb of gameState.orbs) {
    orb.update(delta);
  }

  checkCollisions(delta);

  const allCollected = gameState.collected >= level.orbCount;
  if (allCollected) {
    gameState.beacon.radius = 24 + Math.sin(Date.now() * 0.005) * 4;
    if (Math.hypot(player.x - gameState.beacon.x, player.y - gameState.beacon.y) <
      player.radius + gameState.beacon.radius
    ) {
      nextLevel();
    }
  }
}

function draw() {
  const level = getCurrentLevel();
  drawBackground(level);
  gameState.beacon.draw(level, gameState.collected >= level.orbCount);
  for (const orb of gameState.orbs) {
    orb.draw();
  }
  for (const hazard of gameState.hazards) {
    hazard.draw();
  }
  player.draw(level);
  drawEnergy();
  drawStatusOverlay();
}

function gameLoop(timestamp) {
  if (!gameState.lastTime) gameState.lastTime = timestamp;
  const delta = timestamp - gameState.lastTime;
  gameState.lastTime = timestamp;
  if (gameState.status === "playing") {
    gameState.elapsed += delta;
    updateHUD();
    update(delta * 0.1);
  }
  draw();
  requestAnimationFrame(gameLoop);
}

window.addEventListener("keydown", (event) => {
  if (event.key === "ArrowUp" || event.key === "w") INPUT.up = true;
  if (event.key === "ArrowDown" || event.key === "s") INPUT.down = true;
  if (event.key === "ArrowLeft" || event.key === "a") INPUT.left = true;
  if (event.key === "ArrowRight" || event.key === "d") INPUT.right = true;
  if (event.key === "r") resetGame();
});

window.addEventListener("keyup", (event) => {
  if (event.key === "ArrowUp" || event.key === "w") INPUT.up = false;
  if (event.key === "ArrowDown" || event.key === "s") INPUT.down = false;
  if (event.key === "ArrowLeft" || event.key === "a") INPUT.left = false;
  if (event.key === "ArrowRight" || event.key === "d") INPUT.right = false;
});

function init() {
  resetGame();
  updateHUD();
  requestAnimationFrame(gameLoop);
}

init();
