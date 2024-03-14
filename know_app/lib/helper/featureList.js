function featureList(featureTemp, token) {
  const featureList = [];
  for (const d of featureTemp) {
    const label = d["tkFunction"];
    if (d["tkNumber"] === -1) {
      featureList.push({ [label]: "" });
      continue;
    }
    const currToken = token[d["tkNumber"]];
    const value = currToken.substring(d["startIndx"], d["endIndx"]);
    featureList.push({ [label]: value });
  }
  return featureList;
}
