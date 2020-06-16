const applyContent = ({ dataset, textContent }) => {
  const target = document.getElementById(dataset.target);
  const mirror = document.getElementById(dataset.mirror);

  const targetDoc = target.contentWindow.document;
  targetDoc.write(textContent);
  targetDoc.close();

  mirror.textContent = textContent;

  return target;
};

const makeApplyScale = (target) => () => {
  const { parentNode, contentWindow } = target;

  const scale = Math.min(parentNode.offsetWidth / target.width, 1);
  const height = contentWindow.document.documentElement.scrollHeight;

  if (scale && height) {
    parentNode.style.height = `${height * scale}px`;
    target.style.transform = `scale(${scale})`;
    target.style.height = `${height}px`;
  }
};

export default {
  mounted() {
    const target = applyContent(this.el);
    const applyScale = makeApplyScale(target);

    target.style.transformOrigin = 'top left';

    applyScale();
    target.addEventListener('load', applyScale);
    window.addEventListener('resize', applyScale);
    window.addEventListener('tabs:update', applyScale);
  },
  updated() {
    applyContent(this.el);
  },
};
