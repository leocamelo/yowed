export default {
  mounted() {
    const { el } = this;

    const openDelay = 100;
    const closeDelay = 200;

    setTimeout(() => {
      el.classList.add('is-active');
    }, openDelay);

    el.querySelector('.delete').addEventListener('click', () => {
      el.classList.remove('is-active');
      setTimeout(() => this.pushEventTo(`#${el.id}`, 'close'), closeDelay);
    });
  },
};
