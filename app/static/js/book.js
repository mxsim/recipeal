(() => {
  const API = {
    list: () => `/book/api/list`,
    add: () => `/book/api/add`,
    del: (id) => `/book/api/delete/${id}`,
    stats: () => `/book/api/stats`
  };

  const titleInput = document.getElementById('recipeTitle');
  const descInput = document.getElementById('recipeDesc');
  const imgInput = document.getElementById('recipeImg');
  const createBtn = document.getElementById('bookCreateBtn');
  const bookTable = document.getElementById('bookTable');
  const bookTotals = document.getElementById('bookTotals');

  async function loadBook() {
    try {
      const res = await fetch(API.list());
      const data = await res.json();
      renderTable(data);
      await refreshStats();
    } catch (e) {
      console.error('Failed loading book', e);
    }
  }



  async function createRecipe() {
    const title = titleInput.value.trim();
    const description = descInput.value.trim();
    const image = imgInput.value.trim();
    if (!title) return;
    try {
      const res = await fetch(API.add(), {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ title, description, image })
      });
      if (!res.ok) throw new Error('create failed');
      const data = await res.json();
      renderTable(data);
      titleInput.value = '';
      descInput.value = '';
      imgInput.value = '';
      await refreshStats();
    } catch (err) {
      console.error(err);
    }
  }

  async function deleteRecipe(id) {
    try {
      const res = await fetch(API.del(id), { method: 'DELETE' });
      if (!res.ok) throw new Error('delete failed');
      await loadBook();
    } catch (err) {
      console.error(err);
    }
  }

  async function refreshStats() {
    try {
      const res = await fetch(API.stats());
      const data = await res.json();
      bookTotals.innerHTML = `<div class="book-page__total">Recipes: ${data.recipes_total}</div>`;
    } catch (e) {
      console.error(e);
    }
  }

  window.addEventListener('DOMContentLoaded', () => {
    loadBook();
    createBtn.addEventListener('click', createRecipe);
  });
})();
