const toggle = (el, i, j) => {
  if (i == j) {
    el.classList.add('is-active');
  } else {
    el.classList.remove('is-active');
  }
};

export default {
  mounted() {
    const { el } = this;
    const target = document.getElementById(el.dataset.target);

    const triggers = el.querySelectorAll('li');
    const contents = target.querySelectorAll('.tabs-content-item');

    triggers.forEach((trigger, i) => {
      trigger.addEventListener('click', () => {
        triggers.forEach((t, j) => toggle(t, i, j));
        contents.forEach((c, j) => toggle(c, i, j));
      });
    });
  },
};
