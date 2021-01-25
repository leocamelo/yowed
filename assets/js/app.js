import '../css/app.scss';

import 'phoenix_html';

import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';


import modal from './modal';
import burger from './burger';
import tabs from './tabs';
import templateEditor from './template-editor';
import templatePreview from './template-preview';
import toast from './toast';


const hooks = {
  modal,
  burger,
  tabs,
  templateEditor,
  templatePreview,
  toast,
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
