#!/bin/sh
echo 'Select an option and press Enter: '
options=("web" "app")
select opt in "${options[@]}"; do
  case $opt in
    "web")
      PROJECT_NAME="dental-case-web"
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

echo 'Entrando em' $opt
cd $opt/

echo "Instalando os packages..."
npm install

echo "Done! =)"
