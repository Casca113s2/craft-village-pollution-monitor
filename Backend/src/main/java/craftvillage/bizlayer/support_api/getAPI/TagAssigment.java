package craftvillage.bizlayer.support_api.getAPI;

import java.io.BufferedReader;
import java.io.Closeable;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Arrays;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class TagAssigment {
	public static String getTagImageByURL(String[] urlImages) throws IOException {
		
		String https_url = "http://localhost:9000";
		JSONArray jsonArray = new JSONArray();
		for(int i = 0;i < urlImages.length;++i) {
			jsonArray.add(urlImages[i]);
		}
		JSONObject jsonObject = new JSONObject();
		jsonObject.put("Images", jsonArray);
		
		String body = post(https_url, jsonObject.toJSONString());
		return body;
	}
	public static String post(String postUrl, String data) throws IOException {
        URL url = new URL(postUrl);
        HttpURLConnection con = (HttpURLConnection) url.openConnection();
        con.setRequestMethod("POST");
        con.setRequestProperty("Content-Type", "application/json");
        con.setDoOutput(true);
        sendData(con, data);
        return read(con.getInputStream());
    }

    protected static void sendData(HttpURLConnection con, String data) throws IOException {
        DataOutputStream wr = null;
        try {
            wr = new DataOutputStream(con.getOutputStream());
            wr.writeBytes(data);
            wr.flush();
            wr.close();
        } catch(IOException exception) {
            throw exception;
        } finally {
            closeQuietly(wr);
        }
    }

    private static String read(InputStream is) throws IOException {
        BufferedReader in = null;
        String inputLine;
        StringBuilder body;
        try {
            in = new BufferedReader(new InputStreamReader(is));

            body = new StringBuilder();

            while ((inputLine = in.readLine()) != null) {
                body.append(inputLine);
            }
            in.close();

            return body.toString();
        } catch(IOException ioe) {
            throw ioe;
        } finally {
            closeQuietly(in);
        }
    }

    protected static void closeQuietly(Closeable closeable) {
        try {
            if( closeable != null ) {
                closeable.close();
            }
        } catch(IOException ex) {

        }
    }
}