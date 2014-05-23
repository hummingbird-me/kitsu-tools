### Commit informations
The Hummingbird changelog is automatically labeling commits based on their commit message.
It currently supports the labels `ADD` and `FIX` as well as the `MISC` label if no word in the commit message match any of the words from the add or fix lists.  
The `FIX` label has a higher priority than the `ADD` label, the script will check every word in the commit message starting from the left side. So `Fixed button to add an anime` Would be labled as a `FIX`  
The following is a small list of words that can be used to specify a commit type. The changelog script checks for `word`, `word+ed` and `word+ing`.  

| Label | Words |
| --- | --- |
|`ADD` | `add`  `update`  `create`  `complete`  `increase`  `change`  `new`  `try`  `hook` |
|`FIX` | `fix`  `remove`  `drop`  `revert`  `decrease`  `hide`  `stop`  `clear`  `disallow` |

