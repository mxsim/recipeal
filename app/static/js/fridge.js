// static/js/fridge.js
(() => {
  const API = {
    ingredients: (q) => `/fridge/api/ingredients?query=${encodeURIComponent(q)}`,
    fridgeGet: () => `/fridge/api/items`,
    fridgeAdd: () => `/fridge/api/add`,
    fridgeRemove: (id) => `/fridge/api/remove/${id}`,
    fridgeSummary: () => `/fridge/api/summary`
  };

  // cached color mapping for nutrient keys
  let nutrientColors = {}; // e.g. { calories: "#abc", proteins: "#..." }

  // generate pastel random color
  function randColor() {
    const r = Math.floor(130 + Math.random() * 90);
    const g = Math.floor(130 + Math.random() * 90);
    const b = Math.floor(130 + Math.random() * 90);
    return `rgb(${r}, ${g}, ${b})`;
  }

  // ensure a nutrient has color
  function colorFor(nutr) {
    if (!nutrientColors[nutr]) nutrientColors[nutr] = randColor();
    return nutrientColors[nutr];
  }

  // DOM refs
  const ingredientSearch = document.getElementById('ingredientSearch');
  const ingredientSuggestions = document.getElementById('ingredientSuggestions');
  const amountInput = document.getElementById('ingredientAmount');
  const unitSelect = document.getElementById('ingredientUnit');
  const createBtn = document.getElementById('fridgeCreateBtn');
  const fridgeTable = document.getElementById('fridgeTable');
  const totalsContainer = document.getElementById('totalsContainer');

  // helper to debounce
  function debounce(fn, wait=250){
    let t;
    return (...args) => {
      clearTimeout(t);
      t = setTimeout(()=>fn(...args), wait);
    };
  }

  // autocomplete
  async function fetchSuggestions(q) {
    if (!q || q.trim().length === 0) {
      ingredientSuggestions.classList.remove('show');
      ingredientSuggestions.innerHTML = '';
      return;
    }
    try {
      const res = await fetch(API.ingredients(q));
      if (!res.ok) throw new Error('Autocomplete failed');
      const data = await res.json();
      renderSuggestions(data);
    } catch(err) {
      console.error(err);
    }
  }

  function renderSuggestions(items) {
    ingredientSuggestions.innerHTML = '';
    if (!items || items.length === 0) {
      ingredientSuggestions.classList.remove('show');
      return;
    }
    items.forEach(it => {
      const li = document.createElement('li');
      li.textContent = it.name;
      li.dataset.id = it.id;
      li.addEventListener('click', () => {
        ingredientSearch.value = it.name;
        ingredientSuggestions.classList.remove('show');
      });
      ingredientSuggestions.appendChild(li);
    });
    ingredientSuggestions.classList.add('show');
  }

  // load fridge
async function loadFridge() {
  try {
    const res = await fetch(API.fridgeGet());
    const items = await res.json();
    renderTable(items);
    await refreshTotals();
  } catch (err) {
    console.error('Failed loading fridge', err);
  }
}




  // render table rows
  function renderTable(items) {
    fridgeTable.innerHTML = '';
    // for consistent coloring, pre-register nutrient keys found in items
    const nutrientKeys = ['calories','proteins','fats','carbs'];
    nutrientKeys.forEach(k => colorFor(k));

    items.forEach(it => {
      const row = document.createElement('div');
      row.className = 'fridge-page__row';
      // name
      const nameEl = document.createElement('div');
      nameEl.className = 'fridge-page__name';
      nameEl.textContent = it.name;
      row.appendChild(nameEl);

      // nutrients block
      const nutrientsWrap = document.createElement('div');
      nutrientsWrap.className = 'fridge-page__nutrients';

      // produce pill for each nutrient
      const nutrientList = [
        ['calories', it.calories],
        ['proteins', it.proteins],
        ['fats', it.fats],
        ['carbs', it.carbs]
      ];
      nutrientList.forEach(([k,v]) => {
        const pill = document.createElement('span');
        pill.className = 'fridge-page__nutrient';
        const bg = colorFor(k);
        pill.style.background = bg;
        pill.textContent = `${k}: ${v ?? 0}`;
        nutrientsWrap.appendChild(pill);
      });

      row.appendChild(nutrientsWrap);

      // amount
      const amountEl = document.createElement('div');
      amountEl.className = 'fridge-page__amount';
      amountEl.textContent = it.amount;
      row.appendChild(amountEl);

      // unit
      const unitEl = document.createElement('div');
      unitEl.className = 'fridge-page__measurement';
      unitEl.textContent = it.unit;
      row.appendChild(unitEl);

      // delete
      const delBtn = document.createElement('button');
      delBtn.className = 'fridge-page__delete';
      delBtn.textContent = '✕';
      delBtn.addEventListener('click', async () => {
        await deleteFridgeItem(it.fridge_id);
      });
      row.appendChild(delBtn);

      fridgeTable.appendChild(row);
    });
  }

  // create (POST)
  async function createFridgeItem() {
    const name = ingredientSearch.value.trim();
    const amount = amountInput.value;
    const unit = unitSelect.value;
    if (!name || !amount) return;

    try {
      const res = await fetch(API.fridgeAdd(), {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ name, amount, unit })
      });
      if (!res.ok) throw new Error('create failed');
      // API returns updated list
      const items = await res.json();
      ingredientSearch.value = '';
      amountInput.value = '';
      ingredientSuggestions.classList.remove('show');
      renderTable(items);
      await refreshTotals();
    } catch(err) {
      console.error(err);
    }
  }

  // delete (DELETE)
  async function deleteFridgeItem(fridgeId) {
  try {
    const res = await fetch(API.fridgeRemove(fridgeId), { method: 'DELETE' });
    if (!res.ok) throw new Error('delete failed');
    await loadFridge(); // reloads table and totals
  } catch(err) {
    console.error(err);
  }
}


  // refresh totals and ensure colors match pills
  async function refreshTotals() {
    try {
      const res = await fetch(API.fridgeSummary());
      if (!res.ok) throw new Error('summary failed');
      const data = await res.json();
      renderTotals(data.totals);
      // ensure total color labels match existing nutrient colors
    } catch(err) {
      console.error(err);
    }
  }

  function renderTotals(totals) {
    totalsContainer.innerHTML = '';
    // ensure mapping for each key
    Object.keys(totals).forEach(k => colorFor(k));
    // ordered display
    const order = ['calories','proteins','fats','carbs'];
    order.forEach(key => {
      const row = document.createElement('div');
      row.className = 'fridge-page__total';
      const label = document.createElement('div');
      label.textContent = key.charAt(0).toUpperCase() + key.slice(1);
      label.style.fontWeight = 700;
      const value = document.createElement('div');
      value.textContent = (totals[key] ?? 0) + (key === 'calories' ? ' kcal' : ' g');
      // colorize label text with same color used in pills (but lightened)
      const bg = colorFor(key);
      // set label text color equal to bg for "matching" effect as requested
      label.style.color = bg;
      row.appendChild(label);
      row.appendChild(value);
      totalsContainer.appendChild(row);
    });
  }

  // attach events
  const debouncedFetch = debounce((e) => fetchSuggestions(e.target.value), 180);
  ingredientSearch.addEventListener('input', debouncedFetch);
  ingredientSearch.addEventListener('focus', (e) => {
    if (ingredientSuggestions.children.length) ingredientSuggestions.classList.add('show');
  });
  document.addEventListener('click', (e) => {
    if (!document.querySelector('.fridge-page__input-wrap').contains(e.target)) {
      ingredientSuggestions.classList.remove('show');
    }
  });

  createBtn.addEventListener('click', createFridgeItem);

  
  async function renderFridge() {
  try {
    const res = await fetch(API.fridgeGet());
    const items = await res.json();
    renderTable(items);
    await refreshTotals();
  } catch (err) {
    console.error('Failed loading fridge', err);
  }
}
window.addEventListener('DOMContentLoaded', () => {
  renderFridge(); // render fridge + totals

  createBtn.addEventListener('click', createFridgeItem);

  document.getElementById('cookBtn').addEventListener('click', () => {
    window.location.href = '/feed?fridge'; // or {{ url_for('main.feed') }} if Flask template
  });
});
  
})();

