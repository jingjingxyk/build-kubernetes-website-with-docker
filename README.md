# kubernetes-website-mirror

kubernetes website mirror and down kuberneter components


```shell

# 1. 只显示目录

ls -F | grep "/$"
ls -al | grep "^d"
# 2. 只显示文件
ls -al | grep "^-"


 ls -al | grep "^-" | awk '{print $9}' >  soft-list.txt
```
