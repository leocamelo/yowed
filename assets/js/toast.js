export default function toast($toast) {
  const turnOn = () => $toast.classList.add('is-active');
  const turnOff = () => $toast.classList.remove('is-active');

  setTimeout(() => {
    turnOn();
    setTimeout(turnOff, 3000);
  }, 100);

  $toast.addEventListener('click', turnOff);
}
