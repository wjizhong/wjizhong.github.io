SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
cd ${SHELL_FOLDER}
mkdocs build
git add .
git commit -m "upload files"
git push
cd ${SHELL_FOLDER}/site
git add .
git commit -m "upload files"
git push
