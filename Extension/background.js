chrome.runtime.onInstalled.addListener(() => {
  chrome.contextMenus.create({
    id: "openInSafari",
    title: "Open in Safari",
    contexts: ["page", "link"]
  });
});

chrome.contextMenus.onClicked.addListener((info, tab) => {
  if (info.menuItemId === "openInSafari") {
    const targetUrl = info.linkUrl || info.pageUrl;
    
    // Send the URL to our native Swift app
    chrome.runtime.sendNativeMessage(
      "com.user.openinsafari",
      { url: targetUrl },
      (response) => {
        if (chrome.runtime.lastError) {
          console.error("Error connecting to native host:", chrome.runtime.lastError);
        } else {
          console.log("Successfully sent URL to Safari:", response);
        }
      }
    );
  }
});
