import bklist from "../model/bklist.js";

const addToList = async (feature, itemName) => {
  // TODO: Add the logic to handle the request
  try {
    itemName = itemName.toString();
    const preExists = await bklist.findOne({ itemName: itemName });
    if (preExists) {
      preExists.bklist = [...preExists.bklist, { itemName: itemName }];
      await preExists.save();
      console.log("blacklist updated");
      return;
    } else {
      var blackListItem = new {
        feature: feature,
        bklist: [
          {
            itemName: itemName,
          },
        ],
      }();
      await blackListItem.save();
      console.log("blacklist added new feature");
      return;
    }
  } catch (error) {
    console.log(error);
    return;
  }
};

export { addToList };
