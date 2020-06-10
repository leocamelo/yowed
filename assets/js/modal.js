export default {
  mounted() {
    const { el } = this;

    const openDelay = 100;
    const closeDelay = 200;

    const turnOn = () => el.classList.add('is-active');
    const turnOff = () => el.classList.remove('is-active');

    setTimeout(turnOn, openDelay);

    el.querySelector('.delete').addEventListener('click', () => {
      turnOff();
      setTimeout(() => this.pushEventTo(`#${el.id}`, 'close'), closeDelay);
    });
  },
};
