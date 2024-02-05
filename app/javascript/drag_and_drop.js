document.addEventListener('DOMContentLoaded', () => {
  const dropzone = document.getElementById('dropzone');
  const fileInput = document.getElementById('fileInput');

  dropzone.addEventListener('dragover', (e) => {
    e.preventDefault(); // デフォルトの処理を防ぐ
    dropzone.style.backgroundColor = '#e9e9e9'; // 背景色を変更
  });

  dropzone.addEventListener('dragleave', (e) => {
    dropzone.style.backgroundColor = '#ffffff'; // 背景色を戻す
  });

  dropzone.addEventListener('drop', (e) => {
    e.preventDefault();
    dropzone.style.backgroundColor = '#ffffff'; // 背景色を戻す
    fileInput.files = e.dataTransfer.files; // ドロップされたファイルをinput要素に設定

    // ファイルリストをクリア
    fileList.innerHTML = '';

    // ドロップされたファイルの名前をリストに追加
    Array.from(e.dataTransfer.files).forEach(file => {
      const li = document.createElement('li');
      li.textContent = file.name; // ファイル名を設定
      fileList.appendChild(li); // リストに項目を追加
    });
  });
});
