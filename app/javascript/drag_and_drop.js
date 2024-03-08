document.addEventListener('turbo:load', () => {
  const dropzone = document.getElementById('dropzone');
  const fileInput = document.getElementById('fileInput');
  const fileList = document.getElementById('fileList');

  if (dropzone) {
    // ドロップするために枠内にマウスポインタが来たとき
    dropzone.addEventListener('dragover', (e) => {
      e.preventDefault(); // デフォルトの処理を防ぐ
      dropzone.style.backgroundColor = '#e9e9e9'; // 背景色を変更
    });

    // 枠内からマウスポインタが外れたとき
    dropzone.addEventListener('dragleave', (e) => {
      dropzone.style.backgroundColor = '#ffffff'; // 背景色を戻す
    });

    let droppedFiles = [];
    // ファイルがドロップされたときの処理
    dropzone.addEventListener('drop', (e) => {
      e.preventDefault();
      droppedFiles = e.dataTransfer.files; // ドロップされたファイルを保存

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

    // アップロードボタンのクリックイベントリスナー
    document.getElementById('file_form').addEventListener('submit', async (e) => {
      e.preventDefault(); // フォームのデフォルトの送信を防ぐ

      // 同じファイル名の既存データが存在するかチェック
      const files = droppedFiles;
      for (const file of files) {
        const page_number = extractPageNumber(file.name);
        const form = e.target;
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content'); // CSRFトークン

        // サーバーにファイルの存在チェックを行う
        const response = await fetch(`/books/${bookId}/images/check_existence?page_number=${page_number}`, {
          method: 'POST',
          headers: {
            'X-CSRF-Token': csrfToken
          }
        });
        if (!response.ok) {
          throw new Error('Server responded with an error');
        }
        const result = await response.json();

        if (result.exists) {
          const isOverwrite = confirm(`${file.name}は既に存在します。上書きしますか？`);
          if (isOverwrite) {
            // ここで既存の画像を削除し、新しいファイルをアップロードする処理を行う
            await uploadFile(file, bookId, page_number, true); // 上書きフラグをtrueに設定
          } else {
            // 「いいえ」が選択された場合の処理
            continue; // 次のファイルの処理に移る
          }
        } else {
          // ファイルが存在しない場合は、新規にアップロード
          await uploadFile(file, bookId, page_number, false);
        }
      }
    });
  }
});

function extractPageNumber(filename) {
  // ファイル名から拡張子を除去してページ番号を抽出
  const page_number = filename.split('.').slice(0, -1).join('.');
  return page_number;
}

async function uploadFile(file, bookId, page_number, overwrite) {
  const url = `/books/${bookId}/images`; // サーバーのファイルアップロードエンドポイント
  const formData = new FormData();
  formData.append('file', file); // ファイルデータ
  formData.append('page_number', page_number); // ページ番号
  formData.append('overwrite', overwrite); // 上書きフラグ

  try {
    const response = await fetch(url, {
      method: 'POST',
      headers: {
        'X-CSRF-Token': csrfToken
      },
      body: formData // FormData オブジェクトを直接指定
    });

    if (response.ok) {
      const data = await response.json(); // サーバーからのレスポンスをJSONとして解析
      console.log('File uploaded successfully', data);
      // 成功した場合の処理をここに記述
    } else {
      console.error('File upload failed', response.statusText);
      // エラー処理をここに記述
    }
  } catch (error) {
    console.error('Error uploading file:', error);
    // 例外処理をここに記述
  }
}
