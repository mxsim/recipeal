document.addEventListener("DOMContentLoaded", () => {
  document.querySelectorAll(".feed-page__card").forEach(card => {
    card.addEventListener("click", () => {
      const recipeId = card.dataset.recipeId;
      if (recipeId) window.location.href = `/recipe/${recipeId}`;
    });

    // make sure children also trigger redirect
    card.querySelectorAll('*').forEach(child => {
      child.addEventListener("click", () => {
        const recipeId = card.dataset.recipeId;
        if (recipeId) window.location.href = `/recipe/${recipeId}`;
      });
    });
  });
});
