package craftvillage.bizlayer.support_api;
import java.io.BufferedReader;
import java.io.IOException;
import java.util.List;

import org.json.simple.parser.ParseException;

import craftvillage.bizlayer.support_api.getAPI.TagAssigment;

public class Test {
	private static BufferedReader objReader;

	public static void main(String[] args) throws ParseException, IOException {
		
		String[] inputs = {"C:\\Users\\DELL\\Desktop\\server-python\\test\\image00074.jpg",
				"C:\\Users\\DELL\\Desktop\\server-python\\test\\image00100.jpg",
				"C:\\Users\\DELL\\Desktop\\server-python\\test\\image01051.jpg",
		};
		// Ouput : {"tags": [<Danh sách các nhãn cho ảnh>], "Result" : [[% ảnh 1 có tag là tags[0],% ảnh 1 có tag là tags[0],][Ảnh 2]]
		String result  = TagAssigment.getTagImageByURL(inputs);
		
		System.out.print(result);
	}
}
