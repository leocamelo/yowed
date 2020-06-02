export default function burger($burger) {
  const $target = document.getElementById($burger.dataset.target);

  $burger.addEventListener('click', () => {
    $burger.classList.toggle('is-active');
    $target.classList.toggle('is-active');
  });
}
