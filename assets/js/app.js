import '../css/app.scss';

import 'phoenix_html';

import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';
// import NProgress from 'nprogress';

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, { params: { _csrf_token: csrfToken } });

liveSocket.connect();

// NProgress.configure({ showSpinner: false });
// window.addEventListener('phx:page-loading-start', () => NProgress.start());
// window.addEventListener('phx:page-loading-stop', () => NProgress.done());

const applyStyle = (id, css) => {
  let $style = document.getElementById(id);

  if (!$style) {
    $style = document.createElement('style');
    $style.type = 'text/css';
    $style.id = id;

    document.head.appendChild($style);
  }

  $style.textContent = css;
};

const behaviors = {
  '.navbar-burger': ($burger) => {
    const $target = document.getElementById($burger.dataset.target);

    $burger.addEventListener('click', () => {
      $burger.classList.toggle('is-active');
      $target.classList.toggle('is-active');
    });
  },

  '.is-autofocus': ($input) => {
    $input.focus();
  },

  '.template-preview': ($preview, query) => {
    const scale = $preview.parentNode.offsetWidth / $preview.width;
    applyStyle('template-preview-style', `${query}{transform:scale(${scale})}`);
  },
};

const applyBehavior = (query) => {
  const $subject = document.querySelector(query);
  if ($subject) behaviors[query]($subject, query);
};

window.addEventListener('phx:page-loading-stop', () => {
  Object.keys(behaviors).forEach(applyBehavior);
});

window.addEventListener('resize', () => {
  applyBehavior('.template-preview');
});
