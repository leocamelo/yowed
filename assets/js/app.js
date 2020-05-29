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

liveSocket.connect();
