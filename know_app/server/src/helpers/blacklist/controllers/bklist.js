import bklist from "../model/bklist.js";

const addToList = async (feature, itemName, itemContent) => {
  // TODO: Add the logic to handle the request
  try {
    itemName = itemName.toString();
    const preExists = await bklist.findOne({
      feature: feature,
      "list.itemName": itemName,
    });
    if (preExists) {
      preExists.list = [
        ...preExists.list,
        { itemName: itemName, itemContent: itemContent },
      ];
      await preExists.save();
      console.log("blacklist updated");
      return;
    } else {
      var blackListItem = new {
        feature: feature,
        list: [
          {
            itemName: itemName,
            itemContent: itemContent,
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
