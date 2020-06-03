import CodeMirror from 'codemirror';
import 'codemirror/mode/xml/xml';


export default {
  mounted() {
    const { el } = this;

    const codeMirror = CodeMirror.fromTextArea(el, {
      autofocus: true,
      lineNumbers: true,
      mode: 'xml',
      theme: 'material',
    });

    codeMirror.on('change', () => {
      el.value = codeMirror.getValue();
      this.pushEventTo('#template-form', 'validate', { template: { body: el.value } });
    });
  },
};
