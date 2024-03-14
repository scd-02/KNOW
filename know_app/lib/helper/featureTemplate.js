function makeFeatureTemplate(token, apiResult) {
  const featureTemp = [];

  for (const key in apiResult) {
    if (apiResult[key] === "") {
      featureTemp.push({
        tkFunction: key,
        tkNumber: -1,
        startIndx: 0,
        endIndx: 0,
      });
      continue;
    }
    const value = String(apiResult[key]).toLowerCase();

    for (let i = 0; i < token.length; i++) {
      const currStr = token[i];
      if (currStr.includes(value)) {
        const tkNumber = i;
        const startIndx = currStr.indexOf(value);
        const endIndx = startIndx + value.length;

        featureTemp.push({
          tkFunction: key,
          tkNumber: tkNumber,
          startIndx: startIndx,
          endIndx: endIndx,
        });
      }
    }
  }
  return featureTemp;
}
