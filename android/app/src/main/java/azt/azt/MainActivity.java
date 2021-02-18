package azt.azt;

import io.flutter.embedding.android.FlutterActivity;

import com.zing.zalo.zalosdk.oauth.ZaloSDK;
import android.content.Intent;

public class MainActivity extends FlutterActivity {
    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        ZaloSDK.Instance.onActivityResult(this, requestCode, resultCode, data);
    }
}
