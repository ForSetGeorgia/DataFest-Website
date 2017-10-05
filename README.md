# DataFest-Website

Source code for [datafest.ge](https://datafest.ge)

# Development process

Change directory to ```src``` and call ```npm run watch``` this will watch src folder for any changes, will call ```ruby build.rb``` in background so files in public folder will be regenerated.

# Folder Structure

```
public
``` - production files used to test and deploy  
```
  assets
```
```    css```  
```    fonts```  
```    images```  
```    js```  
```  partial``` - for each page json file with meta and partial html (generated)  
```    [page].json's```  
```  [page].html's``` - for each page full html file (generated)  
```src``` - development files  
```  data``` - meta data for each page in json format  
```    [page].json's```  
```  layout``` - application layout and partials for it  
```    application.html```  
```    [layout_partials].html's```  
```  page``` - for each page html template that is inserted into application layout, with appropriate content generated based on logic - ordinary, grid, list page  
```    [page_partials].html's```  
```  script```  
```    grid.rb``` - used by build.rb to build grid like pages (speakers, team)  
```    list.rb``` - used by build.rb to build list like pages (partners)  
```  build.rb``` - script to generate files in public folder  

# Deploy Process

Copy/Paste public folder files
