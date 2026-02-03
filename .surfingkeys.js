// Surfingkeys Configuration
// Exclude sites from Surfingkeys keyboard mappings

// Configure blacklist pattern to exclude specific sites
// This pattern matches kagi.com and rememberthemilk.com domains and their subdomains
settings.blacklistPattern = /https?:\/\/([^\/]*\.)?(kagi\.com|rememberthemilk\.com)/i;

// Alternative: You can also use individual patterns like this:
// settings.blacklistPattern = /kagi\.com/i;
// Unmap("<Ctrl-d>", /rememberthemilk\.com/i);
