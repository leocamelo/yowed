export default {
  mounted() {
    const { el } = this;

    const turnOn = () => el.classList.add('is-active');
    const turnOff = () => el.classList.remove('is-active');

    setTimeout(() => {
      turnOn();
      setTimeout(turnOff, 3000);
    }, 100);

    el.addEventListener('click', turnOff);
  },
};
