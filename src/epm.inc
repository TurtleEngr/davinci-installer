%provides davinci-resolve
%incompat davinci-resolve-studio

%postinstall <tmp/post-install.sh
%postremove <tmp/post-rm.sh

%ifdef ProdOS
%include ver-$ProdOS.require
%endif

%include epm.list
