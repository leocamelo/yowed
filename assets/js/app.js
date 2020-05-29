import '../css/app.scss';

import 'phoenix_html';

import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
import NProgress from 'nprogress';

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, { params: { _csrf_token: csrfToken } });

NProgress.configure({ showSpinner: false });

window.addEventListener('phx:page-loading-start', () => NProgress.start());
window.addEventListener('phx:page-loading-stop', () => NProgress.done());

window.addEventListener('phx:page-loading-stop', () => {
  const $burger = document.querySelector('.navbar-burger');
  const $burgerTarget = document.getElementById($burger.dataset.target);

  $burger.addEventListener('click', () => {
    $burger.classList.toggle('is-active');
    $burgerTarget.classList.toggle('is-active');
  });
});

liveSocket.connect();
