#!/bin/sh

# Get project name
PROJECT=`echo $(dirname $(realpath $0)) | sed -r "s@^($(dirname $(dirname $(realpath $0)))/)@@" | sed -r "s@-@@g" | sed -r "s@bash@@g"`

echo 'Select an option and press Enter: '
options=("web" "app")
select opt in "${options[@]}"; do
  case $opt in
    "web")
      PROJECT_NAME="dental-case-web"
       # Ask for update the site
			echo 'Would you like to build and update the site after configuration?'
			options2=("yes" "no")
			select opt2 in "${options2[@]}"; do
				case $opt2 in
					"yes")
						break
						;;
					"no")
						break
						;;
				esac
			done
      break
      ;;
    "app")
      PROJECT_NAME="dental-case-app"
      break
      ;;
  esac
done

# Delete previous project folder
rm -f -r $opt

# Clone 'Dental Case' git repository
git clone https://github.com/GameCase-LAWS/$PROJECT_NAME.git $opt

if [ "$opt" = "app" ];
then
  # Replace 'dental' term for 'clinical'
  sed -i 's/dental/medical/g' $opt/app.json
  sed -i 's/Dental/Medical/g' $opt/app.json
  sed -i 's/DENTAL/MEDICAL/g' $opt/app.json

  # Substituir arquivos de configuração
  cp -r files/config $opt/app

  # Substituir imagens
  cp -r files/assets $opt/app

  # Deletar pasta .git para evitar incidentes
  rm -f -r $opt/.git
fi

if [ "$opt" = "web" ];
then
  # Replace 'dental' term for 'clinical'
  sed -i 's/dental/medical/g' $opt/package.json
  sed -i 's/Dental/Medical/g' $opt/package.json
  sed -i 's/DENTAL/MEDICAL/g' $opt/package.json

  sed -i 's/Dental/Medical/g' $opt/public/index.html

  # Substituir favicon
  cp -r files/assets/icons/favicon.png $opt/public/favicon.png

  # Substituir arquivos de configuração
  cp -r files/config $opt/src

  # Substituir imagens
  cp -r files/assets $opt/src

  # Deletar pasta .git para evitar incidentes
  rm -f -r $opt/.git
fi

if [ "$opt2" = "yes" ]
then
	 echo -e "\nInstalling packages in web/ ..." && cd web/ \
   && npm install && echo -e "\n\e[0;32mPackages installed successfuly.\e[m" || echo -e "\n\e[1;31mError installing packages.\e[m" \
   && npm run build && sudo cp -r build/* /var/www/$PROJECT.games/html/ && sudo service nginx reload
else
	echo -e "\nTo update the site type: \n
	cd web/ && npm run build && sudo cp -r build/* /var/www/$PROJECT.games/html/ && sudo service nginx reload"
fi

echo "Done!"
