package craftvillage.datalayer.dao;

import java.util.ArrayList;
import java.util.List;
import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.Persistence;
import javax.persistence.Query;
import javax.transaction.Transactional;


@Transactional
public class CrudDao<T> {
  static private EntityManagerFactory entityManagerFactory =
      Persistence.createEntityManagerFactory("persistence");
  private Class<T> objectClass;

  public CrudDao(Class<T> type) {
    this.objectClass = type;
  }

  public boolean addObject(T object) {
    EntityManager entityManager = entityManagerFactory.createEntityManager();

    try {
      // Check entity State detach or persist
      if (entityManager.contains(object)) {
        entityManager.getTransaction().begin();
        entityManager.persist(object);
        entityManager.getTransaction().commit();
      } else {
        entityManager.getTransaction().begin();
        entityManager.merge(object);
        entityManager.getTransaction().commit();

      }
      return true;
    } catch (Exception e) {
      // TODO: handle exception
      e.printStackTrace();
      entityManager.getTransaction().rollback();
      System.out.println(e);
      System.out.println("Cannot add Object");
      return false;
    } finally {
      entityManager.close();
    }
  }

  public T findById(int id) {
    EntityManager entityManager = entityManagerFactory.createEntityManager();

    T object = null;
    try {
      // entityManager.refresh(object);
      entityManager.getTransaction().begin();
      object = entityManager.find(objectClass, id);
      entityManager.getTransaction().commit();

      return object;
    } catch (Exception e) {
      // TODO: handle exception
      entityManager.getTransaction().rollback();
      e.printStackTrace();
      System.out.println("Cannot find object");
      return null;
    } finally {
      entityManager.close();
    }

  }

  @SuppressWarnings("unchecked")
  public List<T> queyObject(String hql) {
    EntityManager entityManager = entityManagerFactory.createEntityManager();

    try {
      List<T> lst = new ArrayList<>();
      entityManager.getTransaction().begin();
      Query qr = entityManager.createQuery(hql, objectClass);
      lst = qr.getResultList();
      for (T x : lst) {
        entityManager.refresh(x);
      }
      entityManager.getTransaction().commit();

      return lst;
    } catch (Exception e) {
      // TODO: handle exception
      e.printStackTrace();
      System.out.print("Cannot query object");
      return null;
    } finally {
      entityManager.close();
    }
  }


  public boolean delete(T object) {
    EntityManager entityManager = entityManagerFactory.createEntityManager();
    try {
      entityManager.getTransaction().begin();
      entityManager.remove(entityManager.contains(object) ? object : entityManager.merge(object));
      entityManager.getTransaction().commit();
      return true;
    } catch (Exception e) {
      // TODO: handle exception
      e.printStackTrace();
      entityManager.getTransaction().rollback();
      System.out.print("Cannot delete object");
      return false;
    } finally {
      entityManager.close();
    }

  }

  public boolean deleteList(List<T> objects) {
    EntityManager entityManager = entityManagerFactory.createEntityManager();
    try {
      entityManager.getTransaction().begin();
      for (T object : objects)
        entityManager.remove(entityManager.contains(object) ? object : entityManager.merge(object));
      entityManager.getTransaction().commit();
    } catch (Exception e) {
      e.printStackTrace();
      entityManager.getTransaction().rollback();
      return false;
    } finally {
      entityManager.close();
    }
    return true;
  }

  public int deleteAllByQuery(String queryDelete) {
    EntityManager entityManager = entityManagerFactory.createEntityManager();
    entityManager.getTransaction().begin();
    // entityManager.joinTransaction();
    Query query = entityManager.createQuery(queryDelete);
    int res = query.executeUpdate();
    entityManager.getTransaction().commit();
    return res;
  }
}
