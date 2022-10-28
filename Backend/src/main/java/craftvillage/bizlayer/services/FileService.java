package craftvillage.bizlayer.services;

import java.awt.Image;
import java.awt.geom.AffineTransform;
import java.awt.image.AffineTransformOp;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.Base64;

import javax.imageio.ImageIO;

import org.apache.commons.io.FileUtils;
import org.apache.commons.io.FilenameUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.drew.imaging.ImageMetadataReader;
import com.drew.metadata.Metadata;
import com.drew.metadata.exif.ExifIFD0Directory;
import com.drew.metadata.jpeg.JpegDirectory;

import craftvillage.corelayer.utilities.ConstantParameter;
import craftvillage.datalayer.entities.UrUser;
import craftvillage.datalayer.services.AnswerServ;

@Service
public class FileService {
	
	@Autowired
	AnswerServ answerServ = new AnswerServ();
		
	public String storeFile(MultipartFile file , String path , String user, String fileName) throws Exception {
		
        ImageIO.setUseCache(false);
        
        String pathFile = ConstantParameter.getImageRealPath(path, user);
        
        Path pathFileImage = Paths.get(pathFile + fileName);
        Path pathFileCreate = Paths.get(pathFile);
        Files.createDirectories(pathFileCreate);
        Files.copy(file.getInputStream(), pathFileImage, StandardCopyOption.REPLACE_EXISTING);

        BufferedImage image = transformImage(pathFile + fileName);
        String fileName_small = pathFile  +  FilenameUtils.getBaseName(fileName) + "_small.jpg";                    
        System.out.println("FileName_Small: " + fileName_small);
        scale(image, fileName_small);
       
        return ConstantParameter.getImageLogicPath(user);
    }
	
    public static void scale(BufferedImage fileImage, String dest) throws IOException {
    	  
    	BufferedImage inputImage = fileImage; 
        int scaledWidth = (int) (inputImage.getWidth() * 0.1);
        int scaledHeight = (int) (inputImage.getHeight() * 0.1);    
        BufferedImage outputImage = new BufferedImage(scaledWidth,
        		scaledHeight, inputImage.getType());
        
    	
        Image resized =  inputImage.getScaledInstance( scaledWidth, scaledHeight, Image.SCALE_AREA_AVERAGING);
        outputImage.getGraphics().drawImage(resized, 0, 0 , null);
        ImageIO.write(outputImage, "jpg", new File(dest));
        outputImage.flush();
        inputImage.flush();
    }
    
    public static BufferedImage transformImage(String src) throws Exception {
    	File imageFile = new File(src);
        BufferedImage originalImage = ImageIO.read(imageFile);

        Metadata metadata = ImageMetadataReader.readMetadata(imageFile);
        ExifIFD0Directory exifIFD0Directory = metadata.getDirectory(ExifIFD0Directory.class);
        JpegDirectory jpegDirectory = (JpegDirectory) metadata.getDirectory(JpegDirectory.class);

        int orientation = 1;
        try {
            orientation = exifIFD0Directory.getInt(ExifIFD0Directory.TAG_ORIENTATION);
        } catch (Exception ex) {
           System.out.println("Orientation null");;
        }

        int width = jpegDirectory.getImageWidth();
        int height = jpegDirectory.getImageHeight();

        AffineTransform affineTransform = new AffineTransform();

        switch (orientation) {
        case 1:
            break;
        case 2: // Flip X
            affineTransform.scale(-1.0, 1.0);
            affineTransform.translate(-width, 0);
            break;
        case 3: // PI rotation
            affineTransform.translate(width, height);
            affineTransform.rotate(Math.PI);
            break;
        case 4: // Flip Y
            affineTransform.scale(1.0, -1.0);
            affineTransform.translate(0, -height);
            break;
        case 5: // - PI/2 and Flip X
            affineTransform.rotate(-Math.PI / 2);
            affineTransform.scale(-1.0, 1.0);
            break;
        case 6: // -PI/2 and -width
            affineTransform.translate(height, 0);
            affineTransform.rotate(Math.PI / 2);
            break;
        case 7: // PI/2 and Flip
            affineTransform.scale(-1.0, 1.0);
            affineTransform.translate(-height, 0);
            affineTransform.translate(0, width);
            affineTransform.rotate(3 * Math.PI / 2);
            break;
        case 8: // PI / 2
            affineTransform.translate(0, width);
            affineTransform.rotate(3 * Math.PI / 2);
            break;
        default:
            break;
        }       
        System.out.println("Orientation :" + orientation);
        
        if (orientation == 1)
        {
        	
        	return originalImage;
        }
        AffineTransformOp affineTransformOp = new AffineTransformOp(affineTransform, AffineTransformOp.TYPE_BILINEAR);  
        BufferedImage destinationImage = new BufferedImage(originalImage.getHeight(), originalImage.getWidth(), originalImage.getType());
        destinationImage = affineTransformOp.filter(originalImage, destinationImage);
        
        return destinationImage;
    }
    
    public String base64Encode(String Path) throws IOException
    {
    	File file = new File(Path);
    	byte[] fileContent = FileUtils.readFileToByteArray(file);
        String encodedString = Base64.getEncoder().encodeToString(fileContent);
        fileContent = null;
         
        return encodedString;
    }
    
 
}
