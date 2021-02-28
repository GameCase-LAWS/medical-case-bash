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
rm -f -r $PROJECT_NAME

# Clone 'Dental Case' git repository
git clone https://github.com/GameCase-LAWS/$PROJECT_NAME.git

if [ "$PROJECT_NAME" = "dental-case-app" ];
then
  # Replace 'dental' term for 'medical'
  sed -i '.bak' 's/dental/medical/g' $PROJECT_NAME/app.json
  sed -i '.bak' 's/Dental/Medical/g' $PROJECT_NAME/app.json
  sed -i '.bak' 's/DENTAL/MEDICAL/g' $PROJECT_NAME/app.json

  # Modificar android para ios em app.json
  sed -i '.bak' 's/android-icon/ios-icon/g' $opt/app.json

  # Substituir arquivos de configuração
  cp -r files/config $PROJECT_NAME/app

  # Substituir imagens
  cp -r files/assets $PROJECT_NAME/app

  # Deletar pasta .git para evitar incidentes
  rm -f -r $PROJECT_NAME/.git
fi

if [ "$PROJECT_NAME" = "dental-case-web" ];
then
  # Replace 'dental' term for 'medical'
  sed -i '.bak' 's/dental/medical/g' $PROJECT_NAME/package.json
  sed -i '.bak' 's/Dental/Medical/g' $PROJECT_NAME/package.json
  sed -i '.bak' 's/DENTAL/MEDICAL/g' $PROJECT_NAME/package.json

  sed -i '.bak' 's/Dental/Medical/g' $PROJECT_NAME/public/index.html

  # Substituir favicon
  cp -r files/assets/icons/favicon.png $PROJECT_NAME/public/favicon.png

  # Substituir arquivos de configuração
  cp -r files/config $PROJECT_NAME/src

  # Substituir imagens
  cp -r files/assets $PROJECT_NAME/src

  # Deletar pasta .git para evitar incidentes
  rm -f -r $PROJECT_NAME/.git
fi

echo 'Entrando em ' $opt
cd $opt/
echo "Instalando os packages..."
npm install

echo "Done! =)"
