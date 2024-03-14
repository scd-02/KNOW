function tokenizeTxt(text) {
  const lowerCase = text.toLowerCase();
  let cleanedText = lowerCase.replace(/,/g, "");
  cleanedText = cleanedText.replace(/\//g, " ");
  const tokens = cleanedText.split(/\s+/);
  return tokens;
}

function getLargestString(strings) {
  if (!strings || strings.length === 0) {
    return null; // Return null if the array is empty
  }
  let largestString = strings[0]; // Initialize with the first string
  for (let i = 1; i < strings.length; i++) {
    if (strings[i].length > largestString.length) {
      largestString = strings[i];
    }
  }
  return largestString;
}

function templateTxt(text) {
  const lowerCase = text.toLowerCase();
  let cleanedText = lowerCase.replace(/,/g, "");
  const cleanedTemplateText = cleanedText.replace(
    /[!"#$%&'()*+,-./:;<=>?@[\]^_`{|}~]/g,
    " "
  );
  const templateTokens = cleanedTemplateText
    .split(/\s+/)
    .filter((s) => !/\d/.test(s));
  return templateTokens;
}
