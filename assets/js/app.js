import '../css/app.scss';

import 'phoenix_html';

import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';

import toast from './toast';
import burger from './burger';
import template from './template';

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, { params: { _csrf_token: csrfToken } });

liveSocket.connect();

const behaviors = {
  '.toast': toast,
  '.navbar-burger': burger,
  '.template-preview': template,
  '.is-autofocus': ($input) => $input.focus(),
};

const applyBehaviors = () => {
  Object.entries(behaviors).forEach(([query, callback]) => {
    const $subject = document.querySelector(query);
    if ($subject) callback($subject, query);
  });
};

window.addEventListener('DOMContentLoaded', applyBehaviors);
window.addEventListener('phx:page-loading-stop', applyBehaviors);
