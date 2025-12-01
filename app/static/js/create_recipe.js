document.getElementById('image').addEventListener('change', function(e) {
  const file = e.target.files[0];
  if (file) {
    const preview = document.getElementById('recipe_preview');
    preview.src = URL.createObjectURL(file);
  }
});
