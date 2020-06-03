export default {
  mounted() {
    const { el } = this;
    const target = document.getElementById(el.dataset.target);

    el.addEventListener('click', () => {
      el.classList.toggle('is-active');
      target.classList.toggle('is-active');
    });
  },
};
