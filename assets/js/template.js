function applyStyle(id, css) {
  let $style = document.getElementById(id);

  if (!$style) {
    $style = document.createElement('style');
    $style.type = 'text/css';
    $style.id = id;

    document.head.appendChild($style);
  }

  $style.textContent = css;
}

export default function template($preview, query) {
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
}
