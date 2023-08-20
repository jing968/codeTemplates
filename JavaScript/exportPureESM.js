 // The following code template can import a pure ESM module in a commonJS module following a few steps
 //
 // 1. Dynamiclly import the puse ESM module 
 // 2. Wrap the the dynamic import and export again
 //
 // Taking the "wdio-html-nice-reporter" module as example, it is a pure ESM module,
 // which mean it will prevent me from ==> import { ReportAggregator } from "wdio-html-nice-report";

 const fetchRequiredImport = eval('import("wdio-html-nice-reporter")').then((requireModule) => {
   return requireModule.ReportAggregator
 })

 const wrappedModule = (params) => 
   fetchRequiredImport.then( (reportAggregator) => {
     return new reportAggregator(params)
 })

export default wrappedModule


 // Assuming the following code is coming from another file,
 // you can now import the pure ESM module for use

 import wrappedModule from "./exportPureESM.js"

 reportAggregator = warppedModule({
   outputDir: "...",
   filename: "...",
   reportTitle: "...",
   browswerName: "...",
   showInBrowswer: true,
   Log: logger
 })
