export default {
  mounted() {
    const { el } = this;

    const openDelay = 100;
    const closeDelay = 3000;

    const turnOn = () => el.classList.add('is-active');
    const turnOff = () => el.classList.remove('is-active');

    setTimeout(() => {
      turnOn();
      setTimeout(turnOff, closeDelay);
    }, openDelay);

    el.addEventListener('click', turnOff);
  },
};
