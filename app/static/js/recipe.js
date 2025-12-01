(() => {
  const API = {
    addComment: (recipeId) => `/recipe/${recipeId}/add_comment`,
    deleteComment: (recipeId, commentId) => `/recipe/${recipeId}/delete_comment/${commentId}`
  };

  document.addEventListener("DOMContentLoaded", () => {
    const portionInput = document.getElementById("portionCounter");
    const plusBtn = document.getElementById("portionPlus");
    const minusBtn = document.getElementById("portionMinus");

    const caloriesEl = document.getElementById("calories");
    const proteinsEl = document.getElementById("proteins");
    const fatsEl = document.getElementById("fats");
    const carbsEl = document.getElementById("carbs");

    const nutritionPerPortion = {
      calories: parseFloat(caloriesEl.textContent),
      proteins: parseFloat(proteinsEl.textContent),
      fats: parseFloat(fatsEl.textContent),
      carbs: parseFloat(carbsEl.textContent)
    };

    function updateNutrition() {
      const portion = parseInt(portionInput.value) || 1;
      caloriesEl.textContent = (nutritionPerPortion.calories * portion).toFixed(1);
      proteinsEl.textContent = (nutritionPerPortion.proteins * portion).toFixed(1);
      fatsEl.textContent = (nutritionPerPortion.fats * portion).toFixed(1);
      carbsEl.textContent = (nutritionPerPortion.carbs * portion).toFixed(1);
    }

    plusBtn.addEventListener("click", () => {
      let val = parseInt(portionInput.value) || 1;
      if (val < 50) portionInput.value = val + 1;
      updateNutrition();
    });

    minusBtn.addEventListener("click", () => {
      let val = parseInt(portionInput.value) || 1;
      if (val > 1) portionInput.value = val - 1;
      updateNutrition();
    });

    portionInput.addEventListener("input", () => {
      let val = parseInt(portionInput.value);
      if (isNaN(val) || val < 1) val = 1;
      if (val > 50) val = 50;
      portionInput.value = val;
      updateNutrition();
    });

    // --- Comments ---
    const sendBtn = document.getElementById("sendComment");
    const commentInput = document.getElementById("newComment");
    const commentsContainer = document.getElementById("commentsContainer");
    const recipeId = document.querySelector('input[name="recipe_id"]').value;

    sendBtn.addEventListener("click", async () => {
  const content = commentInput.value.trim();
  if (!content) return;

  try {
    const res = await fetch(API.addComment(recipeId), {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ content, user_id: 1 })
    });

    if (!res.ok) {
      console.error('Failed to post comment');
      return;
    }

    const data = await res.json();

    // Create comment div
    const commentDiv = document.createElement('div');
    commentDiv.className = 'recipe-page__comment';
    commentDiv.dataset.commentId = data.comment_id;

    // Use *exact same HTML structure* as rendered by server
    const avatarPath = (data.user && data.user.avatar)
      ? `/static/${data.user.avatar}`
      : '/static/images/default_user.png';

    commentDiv.innerHTML = `
      <img src="${avatarPath}" alt="${data.user.display_name}">
      <div class="recipe-page__comment-content">
        <strong>${data.user.display_name}</strong>
        <span>${data.content}</span>
      </div>
      <button class="comment-delete-btn">X</button>
    `;

    // Append to container
    commentsContainer.appendChild(commentDiv);
    commentInput.value = '';
    commentsContainer.scrollTop = commentsContainer.scrollHeight;

  } catch (err) {
    console.error('Error posting comment', err);
  }
});



    commentsContainer.addEventListener("click", async (e) => {
      if (e.target.classList.contains("comment-delete-btn")) {
        const commentDiv = e.target.closest(".recipe-page__comment");
        const commentId = commentDiv.dataset.commentId;

        const res = await fetch(API.deleteComment(recipeId, commentId), { method: "DELETE" });
        if (res.ok) commentDiv.remove();
      }
    });
  });
})();
