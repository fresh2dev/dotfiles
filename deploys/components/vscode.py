from deploys.utils import link, link_directory_contents

link_directory_contents(".config/Code")

link_directory_contents(".config/Code", ".config/VSCodium")

link(".vim/snippets", ".config/Code/User/snippets")
link(".vim/snippets", ".config/VSCodium/User/snippets")
