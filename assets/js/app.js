import '../css/app.scss';

import 'phoenix_html';

import { Socket } from 'phoenix';
import { LiveSocket } from 'phoenix_live_view';

const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');
const liveSocket = new LiveSocket('/live', Socket, { params: { _csrf_token: csrfToken } });

liveSocket.connect();

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
    const $parent = $preview.parentNode;
    const $win = $preview.contentWindow;

    let cache = null;

    const applyScale = () => {
      const scale = $parent.offsetWidth / $preview.width;
      const height = $win.document.documentElement.scrollHeight;
      const cacheKey = `${scale}/${height}`;

      if (cacheKey != cache) {
        cache = cacheKey;
        applyStyle('template-preview-style', `
          ${query}-container{height:${height * scale}px}
          ${query}{height:${height}px;transform:scale(${scale})}
        `);
      }
    };

    applyScale();
    window.addEventListener('resize', applyScale);
    $preview.addEventListener('load', applyScale);
  },
};

window.addEventListener('phx:page-loading-stop', () => {
  Object.entries(behaviors).forEach(([query, callback]) => {
    const $subject = document.querySelector(query);
    if ($subject) callback($subject, query);
  });
});
