const mjml2html = require('mjml');

module.exports = (body) => mjml2html(body, {
  ignoreIncludes: true,
  minify: false,
}).html;
