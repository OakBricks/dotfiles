function openReddit() {
    window.location.href = "https://www.reddit.com"
}

function openTwitter() {
    window.location.href = "https://www.twitter.com"
}

function openWikipedia() {
    window.location.href = "https://en.wikipedia.org"
}

function searchUsingNotGoogle() {
    const searchBar = document.getElementById("searchbar");
    console.log("attempting a search");
    var xmlHttpReq = new XMLHttpRequest();
    document.domain = "https://serpapi.com"
    xmlHttpReq.open("GET", `https://serpapi.com/search.json?q=${searchBar.innerHTML}&hl=en&gl=us&google_domain=google.com`, false);
    xmlHttpReq.send("");
    return xmlHttpReq.responseType;
}