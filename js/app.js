let app=()=>{
    console.log("kubernetes-tools");
    if(location.protocol == 'http:') {
        location.href=location.href.replace('http:','https:');
    }
    let link=document.createElement('link');
    link.setAttribute('rel','stylesheet');
    link.setAttribute('type','text/css');
    link.setAttribute('href','/css/app.css');
    document.head.appendChild(link);

    (async()=>{
       let res  = await fetch('/soft-list.txt');
       let result = await res.text();
       let files = result.split('\n');
        let content='';
        files.forEach((value,index,files)=>{
            if(value.length<1) {
                return;
            }
            content +=`<li><a href="/${value}" target="_blank">${value}</a></li>`

        });
        let wrap=`
        <ul>
        ${content}
        </ul>
        
        `;
        document.querySelector('.content').innerHTML=content;
    })();
}
export  default  app;