import CodeMirror from 'codemirror';
import 'codemirror/mode/xml/xml';


export default {
  mounted() {
    const { el } = this;
    const target = `#${el.form.id}`;

    const editor = CodeMirror.fromTextArea(el, {
      autofocus: true,
      lineNumbers: true,
      mode: 'xml',
      theme: 'material-darker',
    });

    editor.on('change', () => {
      el.value = editor.getValue();
      this.pushEventTo(target, 'validate', { template: { body: el.value } });
    });
  },
};
