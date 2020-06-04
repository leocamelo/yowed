export default {
  mounted() {
    const { el } = this;
    const { parentNode, contentWindow } = el;
    const style = parentNode.querySelector('style');

    const applyScale = () => {
      const { documentElement } = contentWindow.document;
      if (!documentElement) return;

      const scale = Math.min(parentNode.offsetWidth / el.width, 1);
      const height = documentElement.scrollHeight;

      style.textContent = `
        .template-preview-container{height:${height * scale}px}
        .template-preview{height:${height}px;transform:scale(${scale})}
      `;
    };

    applyScale();
    el.addEventListener('load', applyScale);
    window.addEventListener('resize', applyScale);
  },
};
