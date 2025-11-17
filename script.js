const inventory = [
  {
    id: 1,
    title: 'Blazer estructurado lino',
    brand: 'Everlane',
    price: 98,
    size: 'm',
    condition: 'como nuevo',
    style: 'minimal',
    category: 'ropa',
    color: 'arena',
    image: 'https://images.unsplash.com/photo-1521572163474-6864f9cf17ab?auto=format&fit=crop&w=600&q=60',
    seller: 'Laura Mercado',
    likes: 112,
    saves: 54,
    views: 940,
    sales: 18,
  },
  {
    id: 2,
    title: 'Sneakers Arcadia Runner',
    brand: 'Nike',
    price: 120,
    size: 'l',
    condition: 'como nuevo',
    style: 'athleisure',
    category: 'zapatos',
    color: 'blanco',
    image: 'https://images.unsplash.com/photo-1549298916-f52d724204b4?auto=format&fit=crop&w=600&q=60',
    seller: 'Laura Mercado',
    likes: 240,
    saves: 180,
    views: 1210,
    sales: 32,
  },
  {
    id: 3,
    title: 'Bolso nylon utility',
    brand: 'Prada',
    price: 320,
    size: 'm',
    condition: 'como nuevo',
    style: 'street',
    category: 'accesorios',
    color: 'negro',
    image: 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?auto=format&fit=crop&w=600&q=60',
    seller: 'Colectivo Prism',
    likes: 412,
    saves: 298,
    views: 2200,
    sales: 41,
  },
  {
    id: 4,
    title: 'Pantalón cargo técnico',
    brand: 'Alo Yoga',
    price: 78,
    size: 's',
    condition: 'bueno',
    style: 'athleisure',
    category: 'ropa',
    color: 'verde',
    image: 'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?auto=format&fit=crop&w=600&q=60',
    seller: 'Rack Urbano',
    likes: 88,
    saves: 32,
    views: 640,
    sales: 9,
  },
  {
    id: 5,
    title: 'Abrigo lana retro',
    brand: 'Maje',
    price: 210,
    size: 'l',
    condition: 'como nuevo',
    style: 'retro',
    category: 'ropa',
    color: 'camel',
    image: 'https://images.unsplash.com/photo-1469334031218-e382a71b716b?auto=format&fit=crop&w=600&q=60',
    seller: 'Laura Mercado',
    likes: 132,
    saves: 76,
    views: 990,
    sales: 14,
  },
  {
    id: 6,
    title: 'Set vajilla nórdica 8p',
    brand: 'Iittala',
    price: 160,
    size: 'xl',
    condition: 'nuevo',
    style: 'minimal',
    category: 'hogar',
    color: 'gris',
    image: 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=600&q=60',
    seller: 'Casa Circular',
    likes: 52,
    saves: 19,
    views: 540,
    sales: 6,
  },
  {
    id: 7,
    title: 'Botas hiking urbanas',
    brand: 'The North Face',
    price: 145,
    size: 'm',
    condition: 'como nuevo',
    style: 'utility',
    category: 'zapatos',
    color: 'marrón',
    image: 'https://images.unsplash.com/photo-1460353581641-37baddab0fa2?auto=format&fit=crop&w=600&q=60',
    seller: 'Rack Urbano',
    likes: 76,
    saves: 45,
    views: 720,
    sales: 12,
  },
  {
    id: 8,
    title: 'Organizador modular',
    brand: 'Muji',
    price: 48,
    size: 's',
    condition: 'nuevo',
    style: 'minimal',
    category: 'hogar',
    color: 'transparente',
    image: 'https://images.unsplash.com/photo-1503602642458-232111445657?auto=format&fit=crop&w=600&q=60',
    seller: 'Casa Circular',
    likes: 44,
    saves: 31,
    views: 410,
    sales: 11,
  },
  {
    id: 9,
    title: 'Camisa seda vintage',
    brand: 'Escada',
    price: 132,
    size: 'm',
    condition: 'bueno',
    style: 'retro',
    category: 'ropa',
    color: 'azul',
    image: 'https://images.unsplash.com/photo-1524504388940-b1c1722653e1?auto=format&fit=crop&w=600&q=60',
    seller: 'Colectivo Prism',
    likes: 98,
    saves: 39,
    views: 680,
    sales: 8,
  },
  {
    id: 10,
    title: 'Set pesas compactas',
    brand: 'Bala',
    price: 62,
    size: 'm',
    condition: 'nuevo',
    style: 'athleisure',
    category: 'hogar',
    color: 'negro',
    image: 'https://images.unsplash.com/photo-1556817411-31ae72fa3ea0?auto=format&fit=crop&w=600&q=60',
    seller: 'Studio Flow',
    likes: 66,
    saves: 27,
    views: 530,
    sales: 16,
  },
];

const notifications = [
  'Tu item "Blazer estructurado" está en 32 carritos. Considera activar una oferta.',
  'Laura dejó en visto una oferta hace 15 min, recuérdale con un cupón rápido.',
  'Tu estilo athleisure está trending esta semana (+32% views).',
];

const socialActivity = [
  'Sofía comentó "lo necesito" en tus botas hiking.',
  'Diego creó un bundle con 3 piezas de tu clóset.',
  'Carla te siguió después de tu última venta relámpago.',
];

const listingForm = document.getElementById('listingForm');
const autoTags = document.getElementById('autoTags');
const suggestedPrice = document.getElementById('suggestedPrice');
const searchInput = document.getElementById('searchInput');
const sizeFilter = document.getElementById('sizeFilter');
const conditionFilter = document.getElementById('conditionFilter');
const styleFilter = document.getElementById('styleFilter');
const priceRange = document.getElementById('priceRange');
const priceRangeValue = document.getElementById('priceRangeValue');
const categoryFilter = document.getElementById('categoryFilter');
const feedContainer = document.getElementById('feedContainer');
const searchSuggestions = document.getElementById('searchSuggestions');
const chatMessages = document.getElementById('chatMessages');
const offerForm = document.getElementById('offerForm');
const offerValue = document.getElementById('offerValue');
const promoButton = document.getElementById('flashPromo');
const promoStatus = document.getElementById('promoStatus');
const outfitSelection = document.getElementById('outfitSelection');
const outfitPreview = document.getElementById('outfitPreview');
const socialActivityList = document.getElementById('socialActivity');
const kpiViews = document.getElementById('kpiViews');
const kpiConversion = document.getElementById('kpiConversion');
const kpiAov = document.getElementById('kpiAov');
const topItemsTable = document.querySelector('#topItems tbody');
const sellTips = document.getElementById('sellTips');
const notificationList = document.getElementById('notificationList');
const shippingForm = document.getElementById('shippingForm');
const shippingResult = document.getElementById('shippingResult');
const bundleItems = document.getElementById('bundleItems');
const bundleSummary = document.getElementById('bundleSummary');

let conversation = [
  { sender: 'seller', text: 'Hola 👋, gracias por tu interés en las sneakers Arcadia.' },
  { sender: 'buyer', text: '¿Podrías considerar $95? Estoy listo para comprar hoy.' },
  { sender: 'seller', text: 'Puedo bajar a $110 y enviar hoy mismo con pick-up.' },
];

let flashPromoActive = false;
let selectedBundleIds = new Set();

function renderConversation() {
  chatMessages.innerHTML = '';
  conversation.forEach((msg) => {
    const div = document.createElement('div');
    div.className = `message ${msg.sender}`;
    div.textContent = msg.text;
    chatMessages.appendChild(div);
  });
  chatMessages.scrollTop = chatMessages.scrollHeight;
}

function addNotification(message) {
  notifications.unshift(message);
  renderNotifications();
}

function renderNotifications() {
  notificationList.innerHTML = '';
  notifications.slice(0, 5).forEach((note) => {
    const li = document.createElement('li');
    li.textContent = note;
    notificationList.appendChild(li);
  });
}

function renderFeed(items) {
  feedContainer.innerHTML = '';
  items.forEach((item) => {
    const card = document.createElement('article');
    card.className = 'feed-card';
    card.innerHTML = `
      <img src="${item.image}" alt="${item.title}" />
      <div class="content">
        <h3>${item.title}</h3>
        <div class="feed-meta">
          <span>${item.brand} · ${item.condition}</span>
          <strong>$${item.price}</strong>
        </div>
        <p class="muted">${item.style} · ${item.color}</p>
        <div class="feed-meta">
          <span>❤️ ${item.likes}</span>
          <span>💬 ${item.saves}</span>
        </div>
        <div class="feed-actions">
          <button data-action="like" data-id="${item.id}">Like</button>
          <button data-action="save" data-id="${item.id}">Guardar</button>
          <button data-action="follow" data-seller="${item.seller}">Seguir tienda</button>
        </div>
      </div>`;
    feedContainer.appendChild(card);
  });
}

function updateSuggestions() {
  const keywords = new Set();
  inventory.forEach((item) => {
    item.title.split(' ').forEach((word) => keywords.add(word));
    keywords.add(item.brand);
  });
  searchSuggestions.innerHTML = '';
  [...keywords].slice(0, 20).forEach((key) => {
    const option = document.createElement('option');
    option.value = key;
    searchSuggestions.appendChild(option);
  });
}

function filterInventory() {
  const term = searchInput.value.toLowerCase();
  const size = sizeFilter.value;
  const cond = conditionFilter.value;
  const style = styleFilter.value;
  const maxPrice = Number(priceRange.value);
  const category = categoryFilter.value;

  const filtered = inventory.filter((item) => {
    const matchesTerm = term
      ? item.title.toLowerCase().includes(term) || item.brand.toLowerCase().includes(term)
      : true;
    const matchesSize = size ? item.size === size : true;
    const matchesCond = cond ? item.condition === cond : true;
    const matchesStyle = style ? item.style === style : true;
    const matchesPrice = item.price <= maxPrice;
    const matchesCategory = category ? item.category === category : true;
    return matchesTerm && matchesSize && matchesCond && matchesStyle && matchesPrice && matchesCategory;
  });

  renderFeed(filtered);
}

function updatePriceRangeLabel() {
  priceRangeValue.textContent = `Hasta $${priceRange.value}`;
}

function computeSuggestedPrice(brand, category, condition) {
  const candidates = inventory.filter(
    (item) => item.brand.toLowerCase() === brand.toLowerCase() || item.category === category
  );
  if (!candidates.length) return null;
  const avg = candidates.reduce((sum, item) => sum + item.price, 0) / candidates.length;
  const conditionBoost = condition === 'nuevo' ? 1.1 : condition === 'como nuevo' ? 1.05 : 0.9;
  return Math.round(avg * conditionBoost);
}

function updateAutoTags() {
  const formData = new FormData(listingForm);
  const tags = new Set();
  ['brand', 'color', 'style', 'category', 'condition'].forEach((field) => {
    const value = formData.get(field);
    if (value) tags.add(value.toString().toLowerCase());
  });
  autoTags.innerHTML = '';
  tags.forEach((tag) => {
    const span = document.createElement('span');
    span.textContent = tag;
    autoTags.appendChild(span);
  });

  const brand = formData.get('brand');
  const category = formData.get('category');
  const condition = formData.get('condition');
  if (brand && condition) {
    const suggestion = computeSuggestedPrice(brand, category, condition);
    suggestedPrice.textContent = suggestion ? `$${suggestion}` : '—';
  }
}

listingForm.addEventListener('input', updateAutoTags);
listingForm.addEventListener('change', updateAutoTags);

listingForm.addEventListener('submit', (event) => {
  event.preventDefault();
  const formData = new FormData(listingForm);
  const newItem = {
    id: Date.now(),
    title: formData.get('title'),
    brand: formData.get('brand'),
    price: Number(formData.get('price')),
    size: 'm',
    condition: formData.get('condition'),
    style: formData.get('style') || 'minimal',
    category: formData.get('category'),
    color: formData.get('color') || 'neutral',
    image: 'https://images.unsplash.com/photo-1503341455253-b2e723bb3dbb?auto=format&fit=crop&w=600&q=60',
    seller: 'Laura Mercado',
    likes: 0,
    saves: 0,
    views: 0,
    sales: 0,
  };
  inventory.unshift(newItem);
  listingForm.reset();
  suggestedPrice.textContent = '—';
  autoTags.innerHTML = '';
  renderFeed(inventory);
  updateSuggestions();
  renderOutfitSelection();
  renderBundleGrid();
  refreshDashboard();
  addNotification(`Nuevo listing publicado: ${newItem.title}.`);
});

function initFeedInteractions() {
  feedContainer.addEventListener('click', (event) => {
    const button = event.target.closest('button');
    if (!button) return;
    const action = button.dataset.action;
    if (action === 'like' || action === 'save') {
      const item = inventory.find((i) => i.id === Number(button.dataset.id));
      if (!item) return;
      if (action === 'like') item.likes += 1;
      if (action === 'save') item.saves += 1;
      addNotification(`Tu ${item.title} acaba de recibir un ${action}.`);
      filterInventory();
    }
    if (action === 'follow') {
      addNotification(`Nueva seguidora para ${button.dataset.seller}.`);
    }
  });
}

offerForm.addEventListener('submit', (event) => {
  event.preventDefault();
  const offer = Number(offerValue.value);
  if (!offer) return;
  conversation.push({ sender: 'buyer', text: `Oferto $${offer}` });
  const counter = offer >= 110 ? 'Acepto, enviaré etiqueta inmediata.' : `Puedo cerrar en $${offer + 15} con bundle.`;
  setTimeout(() => {
    conversation.push({ sender: 'seller', text: counter });
    renderConversation();
    addNotification('Tienes una contraoferta lista para revisar.');
  }, 800);
  renderConversation();
  offerValue.value = '';
});

promoButton.addEventListener('click', () => {
  flashPromoActive = !flashPromoActive;
  promoStatus.textContent = flashPromoActive
    ? 'Promo activa: 15% OFF por 2h'
    : '—';
  addNotification(flashPromoActive ? 'Activaste una promo relámpago.' : 'Promo finalizada.');
});

function renderOutfitSelection() {
  outfitSelection.innerHTML = '';
  inventory.slice(0, 6).forEach((item) => {
    const label = document.createElement('label');
    label.innerHTML = `<input type="checkbox" value="${item.id}" /> ${item.title} (${item.brand})`;
    label.querySelector('input').addEventListener('change', updateOutfitPreview);
    outfitSelection.appendChild(label);
  });
}

function updateOutfitPreview() {
  const selectedIds = [...outfitSelection.querySelectorAll('input:checked')].map((input) => Number(input.value));
  if (!selectedIds.length) {
    outfitPreview.textContent = 'Selecciona 3 piezas para armar tu outfit.';
    return;
  }
  const selectedItems = inventory.filter((item) => selectedIds.includes(item.id));
  const total = selectedItems.reduce((sum, item) => sum + item.price, 0);
  outfitPreview.textContent = `Outfit ${selectedItems.length} piezas · Total $${total}. Comparte y etiqueta a tus seguidoras.`;
}

function renderSocialActivity() {
  socialActivityList.innerHTML = '';
  socialActivity.forEach((event) => {
    const li = document.createElement('li');
    li.textContent = event;
    socialActivityList.appendChild(li);
  });
}

function refreshDashboard() {
  const views = inventory.reduce((sum, item) => sum + item.views, 0);
  const sales = inventory.reduce((sum, item) => sum + item.sales, 0);
  const avgPrice = inventory.reduce((sum, item) => sum + item.price, 0) / inventory.length;
  kpiViews.textContent = views.toLocaleString();
  const conversion = sales / views;
  kpiConversion.textContent = `${(conversion * 100).toFixed(1)}%`;
  kpiAov.textContent = `$${Math.round(avgPrice)}`;

  const topItems = [...inventory]
    .sort((a, b) => b.sales - a.sales)
    .slice(0, 3);
  topItemsTable.innerHTML = '';
  topItems.forEach((item) => {
    const row = document.createElement('tr');
    row.innerHTML = `<td>${item.title}</td><td>${item.views}</td><td>${item.sales}</td>`;
    topItemsTable.appendChild(row);
  });

  const tips = [];
  if (conversion < 0.2) tips.push('Activa ofertas automáticas al 10% para desbloquear ventas rápidas.');
  if (avgPrice < 90) tips.push('Experimenta con bundles de 3 piezas para subir el ticket promedio.');
  tips.push('Sugerencia: publica más athleisure, +32% de views esta semana.');
  sellTips.innerHTML = '';
  tips.forEach((tip) => {
    const li = document.createElement('li');
    li.textContent = tip;
    sellTips.appendChild(li);
  });
}

function renderBundleGrid() {
  bundleItems.innerHTML = '';
  inventory.slice(0, 6).forEach((item) => {
    const card = document.createElement('div');
    card.className = 'bundle-card';
    card.innerHTML = `
      <strong>${item.title}</strong>
      <span>${item.seller}</span>
      <span>$${item.price}</span>
      <label><input type="checkbox" value="${item.id}" ${selectedBundleIds.has(item.id) ? 'checked' : ''}/> Añadir al bundle</label>
    `;
    card.querySelector('input').addEventListener('change', (e) => {
      const id = Number(e.target.value);
      if (e.target.checked) {
        selectedBundleIds.add(id);
      } else {
        selectedBundleIds.delete(id);
      }
      updateBundleSummary();
    });
    bundleItems.appendChild(card);
  });
  updateBundleSummary();
}

function updateBundleSummary() {
  if (!selectedBundleIds.size) {
    bundleSummary.textContent = 'Selecciona piezas del mismo vendedor para aplicar descuentos.';
    return;
  }
  const selected = inventory.filter((item) => selectedBundleIds.has(item.id));
  const grouped = selected.reduce((acc, item) => {
    acc[item.seller] = acc[item.seller] || [];
    acc[item.seller].push(item);
    return acc;
  }, {});
  const summaries = Object.entries(grouped).map(([seller, items]) => {
    const subtotal = items.reduce((sum, item) => sum + item.price, 0);
    const discount = items.length >= 2 ? subtotal * 0.15 : 0;
    return `${seller}: ${items.length} piezas · subtotal $${subtotal} · descuento $${discount.toFixed(2)}`;
  });
  bundleSummary.textContent = summaries.join(' | ');
}

shippingForm.addEventListener('submit', (event) => {
  event.preventDefault();
  const weight = Number(document.getElementById('weightInput').value);
  const distance = Number(document.getElementById('distanceInput').value);
  const service = document.getElementById('serviceSelect').value;
  const base = 5;
  const variable = weight * 0.8 + distance * 0.02;
  const multiplier = service === 'express' ? 1.25 : 1;
  const cost = (base + variable) * multiplier;
  shippingResult.textContent = `Costo estimado $${cost.toFixed(2)} · Etiqueta y tracking listos para descargar.`;
  addNotification('Etiqueta generada: recuerda dejar el paquete antes de 6pm.');
});

function initPriceRange() {
  updatePriceRangeLabel();
  priceRange.addEventListener('input', () => {
    updatePriceRangeLabel();
    filterInventory();
  });
}

[searchInput, sizeFilter, conditionFilter, styleFilter, categoryFilter].forEach((input) =>
  input.addEventListener('input', filterInventory)
);

function initSocialSection() {
  renderSocialActivity();
}

function init() {
  renderFeed(inventory);
  updateSuggestions();
  filterInventory();
  renderConversation();
  initFeedInteractions();
  renderOutfitSelection();
  initSocialSection();
  refreshDashboard();
  renderNotifications();
  renderBundleGrid();
  initPriceRange();
}

init();
