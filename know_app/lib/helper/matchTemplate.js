function matchTemplate(template, token) {
  let tokenIndex = 0;
  let templateIndex = 0;
  let matchNumber = 0;

  while (templateIndex !== template.length) {
    for (let i = tokenIndex; i < token.length; i++) {
      if (template[templateIndex] === token[i]) {
        tokenIndex = i;
        matchNumber++;
        break;
      }
    }
    templateIndex++;
  }
  return matchNumber;
}
