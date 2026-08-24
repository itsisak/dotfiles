bindkey "^@" autosuggest-accept
bindkey "^N" forward-word # partially accept autosuggestion

function zvm_after_lazy_keybindings() {
  zvm_bindkey vicmd '^@' autosuggest-accept
  zvm_bindkey vicmd '^N' forward-word
}
