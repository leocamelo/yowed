import '../css/app.scss';

import 'phoenix_html';

import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';


import navbarBurger from './navbar-burger';
import templateEditor from './template-editor';
import templatePreview from './template-preview';
import toastNotification from './toast-notification';


const hooks = {
  navbarBurger,
  templateEditor,
  templatePreview,
  toastNotification,
};

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, { params: { _csrf_token: csrfToken }, hooks });

liveSocket.connect();

window.addEventListener('DOMContentLoaded', () => {
  const toast = document.querySelector('.toast');
  if (toast) toastNotification.mounted.call({ el: toast });
});

window.addEventListener('phx:page-loading-stop', () => {
  const autofocus = document.querySelector('.is-autofocus');
  if (autofocus) autofocus.focus();
});
